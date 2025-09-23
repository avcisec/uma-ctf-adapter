---
description: Overview of oSnap Configuration Parameters
---

# oSnap Configuration Parameters

The parameters below are independent parameters on the oSnap module that can be updated after deployment in the SAFE advanced settings.&#x20;

* **Collateral:** The ERC20 token used for the bond. The options are USDC and WETH.
* **Bond:** The bond value is the amount proposers (and disputers) are required to post in the collateral currency. The minimum recommended bond values are 1,500 USDC and 1 WETH.
* **Liveness:** The length of time a proposal can be disputed. The minimum recommended liveness period is 6 hours to allow disputers to verify a proposal follows the rules.

The parameters below are defined within a single ‘rules’ string on oSnap modules that follow recommended settings. The 'rules' string can be updated after deployment.&#x20;

* **Voting Quorum:** The minimum number of vote participation required for a valid proposal. For example, the proposal should not be considered valid if the voting quorum parameter is 50% and the proposal only had 30% voter participation. This is inherited from Snapshot.
* **Voting Period:** The minimum voting period that should be set in the Snapshot proposal. Any voting period set for a proposal that is less than the parameter set in the rules will not be considered a valid proposal.
* **Challenge Period:** The challenge period, also referred to as the liveness period, is the challenge window where disputers can dispute a proposal, and is another knob you can turn to increase security (while accepting UX trade-offs). You can find your oSnap configuration parameters in the advanced settings, by navigating to the oSnap SAFE App. Click on the gears.

<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FWWqg0z13Ww5g3laSVyo3%2FScreenshot%202023-11-21%20at%202.12.05%20PM.png?alt=media&#x26;token=709f22cd-a5f3-4a46-9ad6-66b17c102d1c" alt="" width="375"><figcaption></figcaption></figure>

The configuration parameters will be displayed in the fields below. **Please adjust with caution.**&#x20;

<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2F3BbmCSMbFjtkOTbg6Lwx%2FScreenshot%202023-11-21%20at%202.12.59%20PM.png?alt=media&#x26;token=8ef7e819-7702-44e2-b522-ab80593ce7c8" alt="" width="375"><figcaption></figcaption></figure>
