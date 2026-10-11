import { invoke } from '@tauri-apps/api/core';
import './style.css';
const button = document.querySelector<HTMLButtonElement>('#launch')!;
const status = document.querySelector<HTMLParagraphElement>('#status')!;
button.addEventListener('click', async () => {
  button.disabled = true;
  try { await invoke('launch_game'); status.textContent = 'Gra uruchomiona w osobnym oknie.'; }
  catch (error) { status.textContent = `Nie udało się uruchomić gry: ${String(error)}`; }
  finally { button.disabled = false; }
});
