import Latest from '@/ui/Latest'
import './globals.css'

export default function Home() {
    return (
        <>
            {/* @ts-expect-error Server Component */}
            <Latest />
        </>
    )
}
