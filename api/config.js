// A anon key do Supabase é pública por design; a segurança vem das políticas RLS (schema.sql).
module.exports = (req, res) => {
  res.setHeader('Content-Type', 'application/javascript');
  res.setHeader('Cache-Control', 'no-store');
  res.end('window.CFG=' + JSON.stringify({
    url: process.env.SUPABASE_URL, key: process.env.SUPABASE_ANON_KEY }) + ';');
};
