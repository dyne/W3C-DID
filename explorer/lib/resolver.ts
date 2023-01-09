import { DIDResolutionOptions, DIDResolutionResult, ParsedDID, Resolvable, Resolver } from "did-resolver";
import { getData } from "./fetcher";

const resolver = new Resolver({
    dyne: async function resolve(
        did: string,
        parsed: ParsedDID,
        didResolver: Resolvable,
        options: DIDResolutionOptions
    ): Promise<DIDResolutionResult> {
        // {method: 'mymethod', id: 'abcdefg', did: 'did:mymethod:abcdefg/some/path#fragment=123', path: '/some/path', fragment: 'fragment=123'}
        const didDoc = await getData(`dids/${did}`);
        // If you need to lookup another did as part of resolving this did document, the primary DIDResolver object is passed in as well
        // const parentDID = await didResolver.resolve(...)
        // Return the DIDResolutionResult object
        return didDoc
    }
})

export const resolve = async (didUrl: string): Promise<DIDResolutionResult> => {
    return await resolver.resolve(didUrl)
}
