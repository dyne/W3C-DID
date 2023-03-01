export interface StickyContainerProps {
  children: React.ReactNode;
}

export default function StickyContainer(props: StickyContainerProps) {
  const { children } = props;

  return (
    <div className="sticky top-[60px] p-4 pt-0 bg-white border-b-[1px] border-b-gray-200">
      {children}
    </div>
  );
}
