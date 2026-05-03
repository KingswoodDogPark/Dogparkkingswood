import Stripe from 'stripe';
import { NextResponse } from 'next/server';

export async function POST(request) {
  const body = await request.json();

  if (!process.env.STRIPE_SECRET_KEY || process.env.STRIPE_SECRET_KEY.includes('replace_me')) {
    return NextResponse.json(
      { error: 'Stripe is not connected yet. Add STRIPE_SECRET_KEY in .env.local or your hosting dashboard.' },
      { status: 400 }
    );
  }

  const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000';

  const areaName = `Area ${body.area}`;
  const amount = Number(body.amount);

  if (!amount || amount < 100) {
    return NextResponse.json({ error: 'Invalid payment amount.' }, { status: 400 });
  }

  const session = await stripe.checkout.sessions.create({
    mode: 'payment',
    payment_method_types: ['card'],
    line_items: [
      {
        price_data: {
          currency: 'gbp',
          product_data: {
            name: `Kingswood Dog Park booking — ${areaName}`,
            description: `${body.dogs} dog(s), ${body.date} at ${body.time}`,
          },
          unit_amount: amount,
        },
        quantity: 1,
      },
    ],
    customer_email: body.email,
    metadata: {
      parkName: body.parkName || 'Kingswood Dog Park',
      area: String(body.area || ''),
      dogs: String(body.dogs || ''),
      date: String(body.date || ''),
      time: String(body.time || ''),
      customerName: String(body.customerName || ''),
      phone: String(body.phone || ''),
    },
    success_url: `${siteUrl}/?booking=success`,
    cancel_url: `${siteUrl}/?booking=cancelled#booking`,
  });

  return NextResponse.json({ url: session.url });
}
