"use client";

import clsx from "clsx";
import Icon from "./icons/Icon";
import { Size } from "./types";

export interface IconButtonProps {
  onClick?: () => void;
  icon?: React.ReactNode;
  disabled?: boolean;
  size?: Size;
  transparent?: boolean;
}

export default function IconButton(props: IconButtonProps) {
  const {
    onClick = () => {},
    icon,
    disabled = false,
    size = "md",
    transparent = false,
  } = props;

  const className = clsx(
    "bg-gray-200 hover:bg-gray-300 rounded-md disabled:opacity-30 disabled:cursor-not-allowed shrink-0",
    size === "md" && "p-3 w-10 h-10",
    size === "sm" && "p-1 w-8 h-8",
    transparent && "bg-transparent"
  );

  return (
    <button className={className} onClick={onClick} disabled={disabled}>
      <Icon source={icon} />
    </button>
  );
}
