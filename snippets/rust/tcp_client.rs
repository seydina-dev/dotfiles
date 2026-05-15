use std::io::{self, BufRead, BufReader, Write};
use std::net::TcpStream;

fn main() -> std::io::Result<()> {
    let addr = "127.0.0.1:8080";
    let stream = TcpStream::connect(addr)?;
    println!("[client] connected to {addr}");

    let mut writer = &stream;
    let mut reader = BufReader::new(&stream);
    let stdin = io::stdin();

    for line in stdin.lock().lines() {
        let msg = line?;
        writeln!(writer, "{msg}")?;

        let mut response = String::new();
        reader.read_line(&mut response)?;
        print!("[server] {response}");
    }

    Ok(())
}
