import IconButton from "./IconButton";
import ArrowLeft from "./icons/ArrowLeft";
import ArrowRight from "./icons/ArrowRight";

export interface PaginatorProps {
  page?: number;
  setPage?: (page: number) => void;
  hasMore?: boolean;
}

export default function Paginator(props: PaginatorProps) {
  const { page = 0, setPage = () => {}, hasMore = false } = props;

  const isFirstPage = page === 0;

  function nextPage() {
    if (hasMore) setPage(page + 1);
  }

  function prevPage() {
    if (!isFirstPage) setPage(page - 1);
  }

  return (
    <div className="flex space-x-1 items-center">
      <IconButton
        icon={<ArrowLeft />}
        disabled={isFirstPage}
        onClick={prevPage}
      />
      <span className="w-5 text-center">{page + 1}</span>
      <IconButton
        icon={<ArrowRight />}
        disabled={!hasMore}
        onClick={nextPage}
      />
    </div>
  );
}
