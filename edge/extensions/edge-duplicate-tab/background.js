chrome.commands.onCommand.addListener(async (command) => {
  if (command !== "duplicate-tab") return;
  const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
  if (tab) chrome.tabs.duplicate(tab.id);
});
