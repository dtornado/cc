# Closelly — deploy (Supabase + Vercel)

1. Supabase: crie o projeto, rode `schema.sql` no SQL Editor e copie Project URL + chave anon (Project Settings > API).
   Em Authentication > Providers > Email, desative "Confirm email" (opcional).
2. Suba esta pasta para um repositório no GitHub.
3. Vercel: Add New > Project > importe o repositório (Framework Preset: Other).
4. Em Environment Variables adicione SUPABASE_URL e SUPABASE_ANON_KEY e clique em Deploy.
5. Supabase > Authentication > URL Configuration: coloque o domínio .vercel.app em Site URL.
Obs.: se adicionar/alterar variáveis depois, faça Redeploy.
