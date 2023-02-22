import { getData } from "lib/fetcher";
import { Dispatch, SetStateAction, useEffect, useState } from "react";
import Button from "./Button";
import SearchBar from "./SearchBar";
import Paginator from "./Paginator";

export interface SearchDIDsProps {
  setDIDs?: Dispatch<SetStateAction<string[]>>;
  setLoading?: Dispatch<SetStateAction<boolean>>;
  limit?: number;
}

export default function SearchDIDs(props: SearchDIDsProps) {
  const { setDIDs = () => {}, setLoading = () => {}, limit = 20 } = props;
  const [searchString, setSearchString] = useState("");
  const [hasMore, setHasMore] = useState(false);
  const [page, setPage] = useState(0);

  useEffect(() => {
    getData(
      `dids?search=${searchString}&limit=${limit}&offset=${limit * page}`
    ).then((data) => {
      setDIDs(data.dids);
      setHasMore(data.moreDids);
    });
  }, [searchString, setDIDs, limit, page]);

  useEffect(() => {
    setPage(0);
  }, [searchString]);

  //

  return (
    <div className="flex w-full space-x-6">
      <div className="grow">
        <SearchBar value={searchString} onChange={setSearchString} />
      </div>
      <div className="shrink-0">
        <Paginator page={page} setPage={setPage} hasMore={hasMore} />
      </div>
    </div>
  );
}
