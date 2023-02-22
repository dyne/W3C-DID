import clsx from "clsx";
import Cancel from "./icons/Cancel";
import { Size } from "./types";
import Icon from "./icons/Icon";
import IconButton from "./IconButton";
import Search from "./icons/Search";

export interface SearchBarProps {
  value?: string;
  onChange?: (value: string) => void;
  size?: Size;
}

export default function SearchBar(props: SearchBarProps) {
  const { value = "", onChange = () => {}, size = "md" } = props;

  function clearValue() {
    onChange("");
  }

  const className = clsx(
    size == "md" && "h-10",
    "p-1",
    "flex flex-row items-center",
    "border border-gray-300 rounded-md focus-within:outline"
  );

  return (
    <div className={className}>
      <div className="h-8 w-8 p-1">
        <Icon source={<Search />} />
      </div>

      <input
        className="grow focus:outline-none bg-transparent"
        type="text"
        placeholder="Search for a DID"
        onChange={(e) => {
          onChange(e.target.value);
        }}
        value={value}
        size={1}
      />

      {value && (
        <IconButton
          icon={<Cancel />}
          size="sm"
          transparent
          onClick={clearValue}
        />
      )}
    </div>
  );
}
