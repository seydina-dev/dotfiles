use std::collections::HashMap;
use std::io::{BufRead, BufReader, Write};
use std::net::{TcpListener, TcpStream};
use std::sync::{Arc, Mutex};
use std::thread;

type Clients = Arc<Mutex<HashMap<u64, TcpStream>>>;

fn handle_client(id: u64, stream: TcpStream, clients: Clients) {
    let peer = stream.peer_addr().unwrap();
    println!("[server] client {id} connected from {peer}");

    let mut reader = BufReader::new(&stream);
    let mut line = String::new();

    loop {
        line.clear();
        match reader.read_line(&mut line) {
            Ok(0) => {
                println!("[server] client {id} disconnected");
                clients.lock().unwrap().remove(&id);
                break;
            }
            Ok(_) => {
                let msg = line.trim_end().to_string();
                println!("[server] client {id}: {msg}");
                let broadcast = format!("[{id}] {msg}\n");

                // Broadcast to all other clients
                let mut guard = clients.lock().unwrap();
                for (&cid, mut client) in guard.iter_mut() {
                    if cid != id {
                        let _ = client.write_all(broadcast.as_bytes());
                    }
                }
            }
            Err(e) => {
                eprintln!("[server] error from client {id}: {e}");
                clients.lock().unwrap().remove(&id);
                break;
            }
        }
    }
}

fn main() -> std::io::Result<()> {
    let addr = "127.0.0.1:8080";
    let listener = TcpListener::bind(addr)?;
    let clients: Clients = Arc::new(Mutex::new(HashMap::new()));
    let mut next_id: u64 = 0;

    println!("[server] broadcast server listening on {addr}");

    for stream in listener.incoming() {
        match stream {
            Ok(s) => {
                let id = next_id;
                next_id += 1;

                // Register client — clone stream for the writer side
                let stream_clone = s.try_clone().expect("clone failed");
                clients.lock().unwrap().insert(id, stream_clone);

                let clients_clone = Arc::clone(&clients);
                thread::spawn(move || handle_client(id, s, clients_clone));
            }
            Err(e) => eprintln!("[server] accept error: {e}"),
        }
    }

    Ok(())
}
