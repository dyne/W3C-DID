import clsx, { ClassValue } from "clsx";
import { ReactNode } from "react";

type TypographyProps = {
  children?: ReactNode;
  className?: ClassValue;
};

export const Text = ({ children, className }: TypographyProps) => {
  return <span className={clsx("prose-sm", className)}>{children}</span>;
};

export const Title = ({ children, className }: TypographyProps) => {
  return (
    <span className={clsx("text-md font-semibold", className)}>{children}</span>
  );
};
