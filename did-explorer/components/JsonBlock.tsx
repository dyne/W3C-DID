import hljs from 'highlight.js/lib/core';
import json from 'highlight.js/lib/languages/json';
import 'highlight.js/styles/base16/solarized-light.css';
hljs.registerLanguage('json', json)

export default function JsonBlock({ content }: { content: any }): JSX.Element {
    const myJson = JSON.stringify(content, null, 2)
    const myHtml = hljs.highlight(myJson, { language: 'json' }).value
    return (
        <pre className="overflow-x-scroll">
            <code dangerouslySetInnerHTML={{ __html: myHtml }} />
        </pre>
    )
}