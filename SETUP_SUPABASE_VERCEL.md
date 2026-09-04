# အလွယ်ဆုံး Supabase + Vercel Setup

ဒီ version မှာ `config.js` ကို PC မှာ ကိုယ်တိုင်ဖွင့်ပြီး ပြင်စရာ မလိုတော့ပါ။

## 1) Supabase
- SQL Editor ထဲက `supabase_setup.sql` ကို Run လုပ်ပြီးသားဆိုရင် ဒီအပိုင်းပြီးပါပြီ။
- Authentication → Users → Add user မှာ Admin email/password တစ်ခုဖန်တီးပါ။
- Settings → API မှာ **Publishable key** ကို Copy လုပ်ထားပါ။
- **Secret key / service_role key မသုံးပါနဲ့။**

## 2) GitHub
ဒီ ZIP ထဲက ဖိုင်အားလုံးကို GitHub repository တစ်ခုထဲ Upload လုပ်ပါ။

## 3) Vercel
GitHub repository ကို Vercel မှာ Import လုပ်ပါ။
ပြီးရင် **Settings → Environment Variables** မှာ အောက်က ၂ ခုထည့်ပါ။

Name: `SUPABASE_URL`
Value: Supabase Project URL

Name: `SUPABASE_PUBLISHABLE_KEY`
Value: Supabase Publishable key

`DEFAULT_EVENT_ID` ကို နောက်မှထည့်လို့ရပါတယ်။ URL မှာ `?event=EVENT_ID` သုံးလည်းရပါတယ်။

ပြီးရင် Deploy / Redeploy လုပ်ပါ။

Vercel build အချိန်မှာ `build.js` က `config.js` ကို အလိုအလျောက်ဖန်တီးပေးပါမယ်။

## Security
Publishable/anon key ကို browser ထဲသုံးနိုင်ပေမယ့် Supabase RLS policies ကိုမှန်ကန်စွာထားရပါမယ်။ Secret/service_role key ကို browser code ထဲမထည့်ပါနဲ့။
