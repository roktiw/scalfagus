#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]
use tauri::Manager;
use std::sync::Mutex;
struct GameProcess(Mutex<Option<std::process::Child>>);
#[tauri::command]
fn launch_game(app: tauri::AppHandle, state: tauri::State<GameProcess>) -> Result<(), String> {
    let mut child = state.0.lock().map_err(|e| e.to_string())?;
    if let Some(process) = child.as_mut() {
        if process.try_wait().map_err(|e| e.to_string())?.is_none() { return Ok(()); }
    }
    let root = app.path().resource_dir().map_err(|e| e.to_string())?.join("resources");
    let executable = root.join("Godot");
    let pack = root.join("game.pck");
    *child = Some(std::process::Command::new(executable)
        .arg("--main-pack").arg(pack)
        .spawn().map_err(|e| e.to_string())?);
    Ok(())
}
fn main() {
    tauri::Builder::default()
        .manage(GameProcess(Mutex::new(None)))
        .invoke_handler(tauri::generate_handler![launch_game])
        .run(tauri::generate_context!())
        .expect("Unable to run Scalfagus");
}
