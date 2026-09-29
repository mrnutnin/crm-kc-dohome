import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "KC × DoHome",
  description: "KC × DoHome partnership CRM MVP",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="th"><head><link rel="stylesheet" href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" /></head><body>{children}</body></html>;
}
