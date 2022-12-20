import { Logo } from "./Logo"
import MarketingPill from "./MarketingPills"

const Marketing = () => {
    return (
        <div className="flex flex-col max-w-sm">
            <Logo />
            <MarketingPill definition="DID">A decentralized identifier (DID) is a type of digital identifier that is designed to be self-sovereign, meaning that it is controlled and owned by the individual or entity it identifies, rather than by a central authority. DIDs are created and managed using blockchain technology, which enables them to be decentralized and resistant to tampering.

                DIDs are intended to be used as a way to identify and authenticate individuals and entities online, in a manner that is secure, private, and interoperable. They can be used to represent a wide variety of things, including people, organizations, devices, and even abstract concepts.
            </MarketingPill>
            <MarketingPill definition="SSI">
                Self-sovereign identity (SSI) is a decentralized approach to identity management that empowers individuals and organizations to own, control, and manage their own digital identity, rather than relying on a central authority.
            </MarketingPill>
            <MarketingPill definition="VC">A verifiable credential (VC) is a digital certificate or token that contains information about an individual or entity that has been verified by a trusted third party and can be used to establish the holder&lsquo;s identity or attributes.</MarketingPill>
        </div>)
}

export default Marketing