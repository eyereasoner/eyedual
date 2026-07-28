// Core relational builtins that do not naturally belong to arithmetic, strings, lists, or aggregation.
// They are deterministic filters/projections and should avoid enumerating additional answers.
import { stringTerm, lexicalValue, unify } from '../term.js';

export const coreBuiltins = {
  register(registry) {
    registry.add('local_time', 1, function* ({ goal, env }) {
      const next = env.clone();
      if (unify(goal.args[0], stringTerm(localDateText()), next)) yield next;
    }, { deterministic: true });

    registry.add('difference', 3, function* ({ goal, env }) {
      const endText = lexicalValue(goal.args[0], env);
      const startText = lexicalValue(goal.args[1], env);
      if (!endText || !startText) return;
      const end = parseISODate(endText);
      const start = parseISODate(startText);
      if (!end || !start || compareDateParts(end, start) < 0) return;
      let [ey, em, ed] = end;
      const [sy, sm, sd] = start;
      if (ed < sd) {
        let bm = em - 1;
        let by = ey;
        if (bm === 0) { bm = 12; by--; }
        ed += daysInMonth(by, bm);
        em--;
        if (em === 0) { em = 12; ey--; }
      }
      if (em < sm) { em += 12; ey--; }
      const duration = formatDuration(ey - sy, em - sm, ed - sd);
      const next = env.clone();
      if (unify(goal.args[2], stringTerm(duration), next)) yield next;
    }, { deterministic: true });
  }
};


function localDateText() {
  const fixed = typeof process !== 'undefined' ? process.env?.EYEPL_LOCAL_TIME : null;
  if (fixed) return fixed;

  const now = new Date();
  const yyyy = now.getFullYear();
  const mm = String(now.getMonth() + 1).padStart(2, '0');
  const dd = String(now.getDate()).padStart(2, '0');
  return `${yyyy}-${mm}-${dd}`;
}

function parseISODate(text) {
  const m = /^(\d{4})-(\d{2})-(\d{2})/.exec(text);
  if (!m) return null;
  const y = Number(m[1]), mo = Number(m[2]), d = Number(m[3]);
  if (mo < 1 || mo > 12 || d < 1 || d > daysInMonth(y, mo)) return null;
  return [y, mo, d];
}
function daysInMonth(y, m) {
  return [0,31,((y%4===0&&y%100!==0)||y%400===0)?29:28,31,30,31,30,31,31,30,31,30,31][m] ?? 0;
}
function compareDateParts(a, b) {
  for (let i = 0; i < 3; i++) if (a[i] !== b[i]) return a[i] < b[i] ? -1 : 1;
  return 0;
}
function formatDuration(y, m, d) {
  if (y === 0 && m === 0 && d === 0) return 'P0D';
  return `P${y ? `${y}Y` : ''}${m ? `${m}M` : ''}${d ? `${d}D` : ''}`;
}
