"use client";

export interface ButtonProps {
  onClick?: () => void;
  children: React.ReactNode;
  disabled?: boolean;
}

export default function Button(props: ButtonProps) {
  const { onClick = () => {}, children, disabled = false } = props;

  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className="bg-secondary-80 hover:bg-secondary text-white px-4 py-2 rounded-md disabled:bg-black-60"
    >
      {children}
    </button>
  );
}
