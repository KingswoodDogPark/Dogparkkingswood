import './globals.css';

export const metadata = {
  title: 'Kingswood Dog Park',
  description: 'Secure private dog park hire with four bookable areas.',
};

export default function RootLayout({ children }) {
  return (
    <html lang="en-GB">
      <body>{children}</body>
    </html>
  );
}
