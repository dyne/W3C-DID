const base_url = 'http://95.217.212.123';

export const getData = async (endpoint: string) => {
    const res = await fetch(`${base_url}/${endpoint}`);
    if (!res.ok) {
        throw new Error(`Failed to fetch data from ${endpoint}`);
    }
    return res.json();
}
