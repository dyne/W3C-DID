"use client";
import { getData } from "lib/fetcher";
import { useState, useEffect } from "react";
import DidTable from "./DidTable";
import { Title } from "./Typography";

const limit = 10

type Page = {current: number, more: boolean}
type Query = {text: string, page: number}

type SearchDidProps = {
  onChange: (e: string) => void
  onClick: (e: number) => void
  page: Page
};

const SearchDid = ({ onChange, onClick, page }: SearchDidProps) => {
  const handleOnChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    e.preventDefault();
    onChange(e.target.value);
  }
  const handleOnClick = (e: React.FormEvent<HTMLButtonElement>, next: boolean) => {
    e.preventDefault();
    if(next && page.more) {
      onClick(page.current+1)
    }
    else if(!next && page.current > 0) {
      onClick(page.current-1)
    }
  }
  return (
    <div className="md:w-2/3">
        <form>
          <input className="bg-gray-200 border-2 border-gray-200 w-3/5 py-2 px-4 leading-tight focus:outline-none focus:bg-white focus:border-red-400" type="text" onChange={(e) => handleOnChange(e)}></input>
          <button className="bg-gray-200 border-2 border-gray-200 w-1/10 py-2 px-4 leading-tight focus:outline-none focus:bg-white focus:border-red-400" onClick={(e) => handleOnClick(e, false)}>&lt;</button>
          <span className="bg-gray-200 border-2 border-gray-200 w-1/5 py-2 px-4 leading-tight focus:outline-none focus:bg-white focus:border-red-400">{page.current+1}</span>
          <button className="bg-gray-200 border-2 border-gray-200 w-1/10 py-2 px-4 leading-tight focus:outline-none focus:bg-white focus:border-red-400" onClick={(e) => handleOnClick(e, true)}>&gt;</button>
        </form>
    </div>
  )
}

const Latest = () => {
  const [didQuery, setDidQuery] = useState({text: '', page: 0});
  const [dids, setDids] = useState([]);
  const [page, setPage] = useState({current: 0, more: false});

  useEffect(() => {
    getData(`dids?search=${didQuery.text}&offset=${didQuery.page*limit}&limit=${limit}`).then((data) => {
      // The text changed, return to the first page
      setDids(data.dids);
      setPage({current: didQuery.page, more: data.moreDids})
    });
  }, [didQuery]);
  return (
    <div className="w-full">
      <Title cn={"mb-8"}>DIDs by Dyne.org</Title>
      <SearchDid page={page}
        onClick={(page) => setDidQuery({...didQuery, page})}
        onChange={(text) => setDidQuery({text, page: 0})}/>
      <DidTable dids={dids}/>
    </div>
  )
}

export default Latest;
