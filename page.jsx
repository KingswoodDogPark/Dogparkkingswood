'use client';

import { motion } from 'framer-motion';
import { CalendarDays, Clock, CreditCard, Dog, MapPin, PawPrint, ShieldCheck } from 'lucide-react';
import { useMemo, useState } from 'react';

function Button({ children, className = '', as = 'button', href, onClick, type = 'button' }) {
  const classes = `inline-flex items-center justify-center rounded-full px-6 py-3 font-bold transition ${className}`;
  if (as === 'a') {
    return <a href={href} className={classes}>{children}</a>;
  }
  return <button type={type} onClick={onClick} className={classes}>{children}</button>;
}

function Card({ children, className = '' }) {
  return <div className={`rounded-[2rem] shadow-xl border-0 bg-white ${className}`}>{children}</div>;
}

export default function KingswoodDogParkWebsite() {
  const [area, setArea] = useState('1');
  const [dogs, setDogs] = useState(1);
  const [date, setDate] = useState('');
  const [time, setTime] = useState('08:00');
  const [customerName, setCustomerName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');

  const areaPrice = area === '1' || area === '2' ? 8 : 10;
  const extraDogFee = Math.max(dogs - 3, 0) * 2.5;
  const total = useMemo(() => areaPrice + extraDogFee, [areaPrice, extraDogFee]);

  const timeSlots = ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'];

  async function handleCheckout() {
    if (!customerName || !email || !phone || !date) {
      alert('Please complete your name, email, phone and date before booking.');
      return;
    }

    const booking = {
      parkName: 'Kingswood Dog Park',
      area,
      dogs,
      date,
      time,
      customerName,
      email,
      phone,
      amount: Math.round(total * 100),
      currency: 'gbp',
    };

    try {
      const response = await fetch('/api/create-checkout-session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(booking),
      });

      const data = await response.json();
      if (data?.url) window.location.href = data.url;
      else alert(data?.error || 'Payment setup is not connected yet. Add your Stripe keys to go live.');
    } catch (error) {
      alert('Payment setup is not connected yet. Add your Stripe keys to go live.');
    }
  }

  return (
    <main className="min-h-screen bg-[#f7fbf1] text-slate-900">
      <header className="sticky top-0 z-50 bg-white/90 backdrop-blur border-b">
        <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3 font-black text-2xl text-green-800">
            <PawPrint className="h-8 w-8" /> Kingswood Dog Park
          </div>
          <nav className="hidden md:flex gap-8 font-medium">
            <a href="#home">Home</a>
            <a href="#booking">Book</a>
            <a href="#features">Features</a>
            <a href="#contact">Contact</a>
          </nav>
          <Button as="a" href="#booking" className="bg-green-700 text-white hover:bg-green-800">Book a Visit</Button>
        </div>
      </header>

      <section id="home" className="relative overflow-hidden bg-gradient-to-br from-green-900 via-green-800 to-lime-700 text-white">
        <div className="max-w-7xl mx-auto px-6 py-24 grid lg:grid-cols-2 gap-12 items-center">
          <motion.div initial={{ opacity: 0, y: 18 }} animate={{ opacity: 1, y: 0 }}>
            <p className="uppercase tracking-widest text-lime-200 font-bold mb-4">Secure private dog park hire</p>
            <h1 className="text-5xl md:text-7xl font-black leading-tight mb-6">A better place for dogs to run free.</h1>
            <p className="text-xl text-green-50 mb-8 max-w-xl">Book one of four secure areas at Kingswood Dog Park. Open daily from 8:00 AM to 7:00 PM.</p>
            <div className="flex flex-wrap gap-4">
              <Button as="a" href="#booking" className="bg-lime-400 text-green-950 hover:bg-lime-300">Book Now</Button>
              <Button as="a" href="#features" className="bg-transparent text-white border border-white hover:bg-white hover:text-green-900">See Features</Button>
            </div>
          </motion.div>
          <div className="bg-white/10 rounded-[2rem] p-8 shadow-2xl border border-white/20">
            <div className="aspect-video rounded-[1.5rem] bg-green-100/20 flex items-center justify-center">
              <Dog className="h-32 w-32 text-lime-200" />
            </div>
          </div>
        </div>
      </section>

      <section id="booking" className="py-20 px-6">
        <div className="max-w-6xl mx-auto grid lg:grid-cols-[1.2fr_.8fr] gap-8 items-start">
          <Card>
            <div className="p-8 md:p-10">
              <div className="mb-8">
                <p className="text-green-700 font-bold uppercase tracking-widest">Booking</p>
                <h2 className="text-4xl font-black mt-2">Reserve your area</h2>
                <p className="text-slate-600 mt-3">Area names are coming soon. For now, choose Area 1, 2, 3 or 4.</p>
              </div>

              <div className="grid md:grid-cols-2 gap-5">
                <label className="grid gap-2"><span className="font-semibold">Full name</span><input value={customerName} onChange={(e) => setCustomerName(e.target.value)} className="rounded-2xl border p-4" placeholder="Your name" /></label>
                <label className="grid gap-2"><span className="font-semibold">Email</span><input value={email} onChange={(e) => setEmail(e.target.value)} className="rounded-2xl border p-4" placeholder="you@example.com" /></label>
                <label className="grid gap-2"><span className="font-semibold">Phone</span><input value={phone} onChange={(e) => setPhone(e.target.value)} className="rounded-2xl border p-4" placeholder="07..." /></label>
                <label className="grid gap-2"><span className="font-semibold">Area</span><select value={area} onChange={(e) => setArea(e.target.value)} className="rounded-2xl border p-4 bg-white"><option value="1">Area 1 — £8</option><option value="2">Area 2 — £8</option><option value="3">Area 3 — £10</option><option value="4">Area 4 — £10</option></select></label>
                <label className="grid gap-2"><span className="font-semibold">Date</span><input type="date" value={date} onChange={(e) => setDate(e.target.value)} className="rounded-2xl border p-4" /></label>
                <label className="grid gap-2"><span className="font-semibold">Time</span><select value={time} onChange={(e) => setTime(e.target.value)} className="rounded-2xl border p-4 bg-white">{timeSlots.map((slot) => <option key={slot}>{slot}</option>)}</select></label>
                <label className="grid gap-2 md:col-span-2"><span className="font-semibold">Number of dogs</span><input type="number" min="1" value={dogs} onChange={(e) => setDogs(Number(e.target.value))} className="rounded-2xl border p-4" /><span className="text-sm text-slate-500">Up to 3 dogs included. Extra dogs are £2.50 each.</span></label>
              </div>

              <Button onClick={handleCheckout} className="mt-8 w-full py-5 text-lg bg-green-700 text-white hover:bg-green-800">
                <CreditCard className="mr-2 h-5 w-5" /> Pay £{total.toFixed(2)} & Book
              </Button>
              <p className="text-center text-sm text-slate-500 mt-4">Apple Pay and Google Pay appear automatically in Stripe Checkout when available on the customer’s device.</p>
            </div>
          </Card>

          <div className="space-y-6">
            <Card className="bg-green-900 text-white">
              <div className="p-8">
                <h3 className="text-2xl font-black mb-6">Booking summary</h3>
                <div className="space-y-4 text-green-50">
                  <div className="flex justify-between"><span>Selected area</span><strong>Area {area}</strong></div>
                  <div className="flex justify-between"><span>Base price</span><strong>£{areaPrice.toFixed(2)}</strong></div>
                  <div className="flex justify-between"><span>Dogs</span><strong>{dogs}</strong></div>
                  <div className="flex justify-between"><span>Extra dog fee</span><strong>£{extraDogFee.toFixed(2)}</strong></div>
                  <div className="border-t border-white/20 pt-4 flex justify-between text-2xl"><span>Total</span><strong>£{total.toFixed(2)}</strong></div>
                </div>
              </div>
            </Card>
            <Card><div className="p-8 space-y-5"><div className="flex gap-4"><Clock className="text-green-700" /><div><strong>Opening hours</strong><p>8:00 AM – 7:00 PM daily</p></div></div><div className="flex gap-4"><CalendarDays className="text-green-700" /><div><strong>Memberships</strong><p>Monthly memberships coming soon.</p></div></div><div className="flex gap-4"><ShieldCheck className="text-green-700" /><div><strong>Secure areas</strong><p>Private hire areas for safer, calmer visits.</p></div></div></div></Card>
          </div>
        </div>
      </section>

      <section id="features" className="py-20 bg-white px-6">
        <div className="max-w-6xl mx-auto text-center">
          <p className="text-green-700 font-bold uppercase tracking-widest">Why visit</p>
          <h2 className="text-4xl font-black mt-2 mb-10">Built for dogs. Easy for owners.</h2>
          <div className="grid md:grid-cols-3 gap-6">
            {['Four bookable areas', 'Secure fencing', 'Great for reactive dogs', 'Simple online payment', 'Open 8 AM – 7 PM', 'Memberships coming soon'].map((feature) => (
              <Card key={feature} className="bg-green-50"><div className="p-8 font-bold">{feature}</div></Card>
            ))}
          </div>
        </div>
      </section>

      <section id="contact" className="py-16 px-6 bg-green-950 text-white">
        <div className="max-w-6xl mx-auto grid md:grid-cols-3 gap-8">
          <div><h3 className="text-3xl font-black mb-3">Kingswood Dog Park</h3><p className="text-green-100">A secure, easy-to-book dog park with four private areas.</p></div>
          <div className="flex gap-3"><MapPin /> <p>Address coming soon</p></div>
          <div><p>© 2026 Kingswood Dog Park. All rights reserved.</p></div>
        </div>
      </section>
    </main>
  );
}
