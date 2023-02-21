"use client";

import Marketing from "@/ui/Marketing";
import "./globals.css";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <div className="grid xl:grid-cols-4 p-4">
          <Marketing />
          <div className="col-span-3 w-full">{children}</div>
        </div>
      </body>
    </html>
  );
}
