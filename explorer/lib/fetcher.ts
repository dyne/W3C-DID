const base_url = 'https://did.dyne.org';

export const getData = async (endpoint: string) => {
    const res = await fetch(`${base_url}/${endpoint}`);
    if (!res.ok) {
        throw new Error(`Failed to fetch data from ${endpoint}`);
    }
    return res.json();
}
