use std::io::{BufRead, BufReader, Write};
use std::net::{TcpListener, TcpStream};
use std::thread;

fn handle_client(stream: TcpStream) {
    let peer = stream.peer_addr().unwrap();
    println!("[server] connection from {peer}");

    let mut reader = BufReader::new(&stream);
    let mut writer = &stream;
    let mut line = String::new();

    loop {
        line.clear();
        match reader.read_line(&mut line) {
            Ok(0) => {
                println!("[server] {peer} disconnected");
                break;
            }
            Ok(_) => {
                let msg = line.trim_end();
                println!("[server] recv from {peer}: {msg}");
                let response = format!("echo: {msg}\n");
                if writer.write_all(response.as_bytes()).is_err() {
                    break;
                }
            }
            Err(e) => {
                eprintln!("[server] read error from {peer}: {e}");
                break;
            }
        }
    }
}

fn main() -> std::io::Result<()> {
    let addr = "127.0.0.1:8080";
    let listener = TcpListener::bind(addr)?;
    println!("[server] listening on {addr}");

    for stream in listener.incoming() {
        match stream {
            Ok(s) => {
                thread::spawn(move || handle_client(s));
            }
            Err(e) => eprintln!("[server] accept error: {e}"),
        }
    }

    Ok(())
}
