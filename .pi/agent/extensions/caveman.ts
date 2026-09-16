import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

type Mode = "off" | "lite" | "full" | "ultra" | "wenyan-lite" | "wenyan-full" | "wenyan-ultra";

const modes = new Set<Mode>([
  "off",
  "lite",
  "full",
  "ultra",
  "wenyan-lite",
  "wenyan-full",
  "wenyan-ultra",
]);

const instructions: Record<Exclude<Mode, "off">, string> = {
  lite: "Answer tightly. Remove filler, pleasantries, repetition, and needless hedging. Keep full sentences and all technical substance.",
  full: "Answer terse like smart caveman. Keep all technical substance. Drop articles, filler, pleasantries, repetition, and needless hedging. Fragments are fine; use short exact words.",
  ultra: "Answer with bare, exact fragments. Strip conjunctions and filler; use arrows for causality and standard technical abbreviations only. Keep all technical substance.",
  "wenyan-lite": "以簡潔半文言答覆，去贅語而保語法與全部技術內容。",
  "wenyan-full": "以精簡文言答覆，省主語贅詞，保全部技術內容。",
  "wenyan-ultra": "以極簡文言答覆；能一字則一字，保全部技術內容。",
};

const safety = " Preserve exact code, commands, API names, symbols, and error strings. Use clear normal prose for security warnings, irreversible actions, or any sequence where compression risks ambiguity. Match user's language. Never announce this style.";

function parseMode(raw: string): Mode | undefined {
  const value = raw.trim().toLowerCase();
  if (!value) return "full";
  if (value === "wenyan") return "wenyan-full";
  if (value === "stop" || value === "disable" || value === "normal") return "off";
  return modes.has(value as Mode) ? (value as Mode) : undefined;
}

export default function (pi: ExtensionAPI) {
  let mode: Mode = parseMode(process.env.CAVEMAN_DEFAULT_MODE ?? "full") ?? "full";

  function showStatus(ctx: ExtensionContext) {
    ctx.ui.setStatus("caveman", mode === "off" ? undefined : `caveman:${mode}`);
  }

  function changeMode(next: Mode, ctx: ExtensionContext, persist = true) {
    mode = next;
    if (persist) pi.appendEntry("caveman-mode", { mode });
    showStatus(ctx);
  }

  pi.on("session_start", (_event, ctx) => {
    for (const entry of ctx.sessionManager.getBranch()) {
      if (entry.type !== "custom" || entry.customType !== "caveman-mode") continue;
      const saved = (entry.data as { mode?: string } | undefined)?.mode;
      const parsed = saved ? parseMode(saved) : undefined;
      if (parsed) mode = parsed;
    }
    showStatus(ctx);
  });

  pi.on("before_agent_start", (event) => {
    if (mode === "off") return;
    return { systemPrompt: `${event.systemPrompt}\n\n${instructions[mode]}${safety}` };
  });

  pi.on("input", (event, ctx) => {
    const text = event.text.trim().toLowerCase();
    if (/^(stop|disable|deactivate|turn off) caveman(?: mode)?[.!]?$/.test(text) || text === "normal mode") {
      changeMode("off", ctx);
    }
  });

  pi.registerCommand("caveman", {
    description: "Set terse response mode: lite, full, ultra, wenyan-*, or off",
    handler: async (args, ctx) => {
      const next = parseMode(args);
      if (!next) {
        ctx.ui.notify("Usage: /caveman [lite|full|ultra|wenyan-lite|wenyan-full|wenyan-ultra|off]", "warning");
        return;
      }
      changeMode(next, ctx);
      ctx.ui.notify(next === "off" ? "Caveman mode off" : `Caveman mode: ${next}`, "info");
    },
  });
}
