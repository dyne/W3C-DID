'use client'

import { useState } from "react"

const Copy = ({ text }: { text: string }) => {
    const [copied, setCopied] = useState(false)

    return (
        <div className="text-xs my-1">
            <button
                onClick={async () => {
                    navigator.clipboard.writeText(text).then(() => {
                        setCopied(true)
                    })
                }}
                className="border rounded border border-secondary-60 text-secondary hover:bg-secondary-60 hover:text-white p-1 px-2">copy to clipboard</button>
            <span className="pl-2">{copied ? '✅' : ''}</span>
        </div>
    )
}

export default Copy