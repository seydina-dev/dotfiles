use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel::<String>();

    // Spawn producer thread
    let tx_clone = tx.clone();
    thread::spawn(move || {
        for i in 0..5 {
            let msg = format!("message {i}");
            println!("[producer] sending: {msg}");
            tx_clone.send(msg).unwrap();
            thread::sleep(Duration::from_millis(500));
        }
    });

    drop(tx); // drop original so channel closes after all producers done

    // Consumer on main thread
    for received in rx {
        println!("[consumer] received: {received}");
    }

    println!("channel closed, done.");
}
