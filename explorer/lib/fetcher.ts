const base_url = "https://did.dyne.org";

export const getData = async (endpoint: string) => {
  const res = await fetch(`${base_url}/${endpoint}`);
  if (!res.ok) {
    throw new FetchError(
      res.status,
      `Failed to fetch data from ${endpoint}`,
      res.statusText
    );
  }
  return res.json();
};

export class FetchError extends Error {
  status: number;
  message: string;
  statusText: string;

  constructor(status: number, message: string, statusText: string) {
    super(message);
    this.name = "FetchError";
    this.status = status;
    this.message = message;
    this.statusText = statusText;
  }
}
