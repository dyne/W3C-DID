"use client";

import { useState } from "react";
import Button from "./Button";

export interface CopyButtonProps {
  text?: string;
}

export default function CopyButton(props: CopyButtonProps) {
  const { text = "" } = props;
  const [copied, setCopied] = useState(false);

  function copy() {
    navigator.clipboard.writeText(text).then(() => {
      setCopied(true);
    });
  }

  if (copied)
    setTimeout(() => {
      setCopied(false);
    }, 1000);

  return (
    <div className="flex space-x-1">
      {copied && (
        <div className="bg-gray-800/75 flex items-center rounded-md px-3">
          <span>✅</span>
        </div>
      )}
      <Button onClick={copy}>Copy to clipboard</Button>
    </div>
  );
}
