import clsx, { ClassValue } from "clsx"
import { ReactNode } from "react"

type TypographyProps = {
    children?: ReactNode;
    cn?: ClassValue;
}

export const Text = ({ children, cn }: TypographyProps) => {
    return (
        <span className={clsx("prose-sm", cn)}>
            {children}
        </span>
    )
}
export const Title = ({ children, cn }: TypographyProps) => {
    return (
        <span className={clsx("text-xl font-semibold", cn)}>
            {children}
        </span>
    )
}