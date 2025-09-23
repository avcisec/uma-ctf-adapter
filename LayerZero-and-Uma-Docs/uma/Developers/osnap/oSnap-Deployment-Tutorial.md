# oSnap Deployment Tutorial

Welcome to the oSnap Deployment Tutorial. In this tutorial, you'll find detailed, step-by-step instructions on deploying oSnap for fully decentralized governance.

Before deploying oSnap, you must [set-up a Snapshot space](https://docs.snapshot.org/user-guides/spaces/create) and [Safe](https://help.safe.global/en) with Multi-Sig (or Safe with on-chain governance).&#x20;

## Create a Safe

Visit [https://app.safe.global/](https://app.safe.global/) to deploy and access your Safe.&#x20;

If you do not have a Safe created, select the ‘Create new Safe’ button and follow [these](https://help.gnosis-safe.io/en/articles/3876461-creating-a-safe-on-a-web-browser) instructions to deploy a safe. Select ‘Add existing Safe’ if you would like to use an existing safe with your oSnap module.

:exclamation:_Note: Confirm your wallet is set to the appropriate network if the safe isn’t displayed._

## Create a Snapshot Space

Visit [https://snapshot.org/](https://snapshot.org/#/) to access your Snapshot space.

&#x20;If you do not have a Snapshot space created, follow [these instructions](https://docs.snapshot.org/spaces/create) to get started.&#x20;

## Deploy oSnap

Now that your Safe and Snapshot space are set up, you can deploy oSnap.

In your Snapshot space, click **'Settings'** then '**Advanced'** on the left sidebar.

<div align="center"><figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FYWWs2cdKVssTfgITRtzU%2FScreenshot%202023-11-13%20at%203.35.40%20PM.png?alt=media&#x26;token=538d3f62-f705-43f1-896e-59f484348925" alt="" width="563"><figcaption></figcaption></figure></div>

&#x20;In the Plugins container, click **'Add plugin'.** In the modal that opens, click the **'oSnap by UMA'** option.

<div align="center"><figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FfDLlK5rww5EBdcaQYJaW%2FScreenshot%202023-11-13%20at%203.31.05%20PM.png?alt=media&#x26;token=86822be4-6f29-4c39-8341-1311af23f3bb" alt="" width="563"><figcaption></figcaption></figure></div>

Next, in the treasury container, click **'Add Treasury'**. Then, select the network, and enter the name and contract address of your Safe treasury.

:exclamation:_Note: Make sure you have the **correct chain selected** or oSnap installation will not work. See supported networks_ [_here._](../../resources/network-addresses)

<div align="center"><figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FI15vQ6ngoPDbvwgdVYBi%2FScreenshot%202023-11-13%20at%203.39.14%20PM.png?alt=media&#x26;token=e6ff86e6-be71-4f5e-b543-4bb27ad45455" alt="" width="473"><figcaption></figcaption></figure></div>

Scroll down, click **'Save'** and sign the message.

<div align="center"><figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2Fq7hIhpF1ETzCYXqUxETe%2FScreenshot%202023-11-13%20at%203.32.13%20PM.png?alt=media&#x26;token=a583e6ea-d1bb-43f1-ba53-14bd5db2c7c6" alt="" width="563"><figcaption></figcaption></figure></div>

Once saved, in the treasury container, click **'Activate oSnap'.**

<div align="center"><figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2Fy0GFSiJy9DTCFAZYG5si%2FScreenshot%202023-11-13%20at%203.55.05%20PM.png?alt=media&#x26;token=09407adf-c4fe-4178-b2da-21f55837db65" alt=""><figcaption></figcaption></figure></div>

In the modal that opens, click **'Activate oSnap'.**

<div align="center"><figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2Fu8yIRzVBi0FtYQbjdrdE%2FScreenshot%202023-11-13%20at%203.55.20%20PM.png?alt=media&#x26;token=9a3f3c9e-c51e-461c-9f2b-33ea01d12508" alt="" width="440"><figcaption></figcaption></figure></div>

Next, you will be redirected to the Safe App, click **'Activate oSnap'.**

<div align="center"><figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2F2Optm0m7KnOcDVbBZYGW%2FScreenshot%202023-11-13%20at%203.56.18%20PM.png?alt=media&#x26;token=b61544e0-0acf-4c63-98ab-f8ab85d70562" alt="" width="486"><figcaption></figcaption></figure></div>

Execute the generated transaction on your Safe.&#x20;

<div align="center"><figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FvA2POdzlGxWO8o3pYxZl%2FScreenshot%202023-11-13%20at%204.02.30%20PM.png?alt=media&#x26;token=41e0829c-8fb9-4e37-9acb-1fa617b71f6d" alt="" width="527"><figcaption></figcaption></figure></div>

Once the transaction is confirmed, you should see that oSnap is activated in two places:

First, confirm it's activated in the Safe App.&#x20;

<figure><img src="https://lh7-us.googleusercontent.com/4FfjTorCvSnDlA4d8hu6kGCOOooUUD_HMEvTx1otiq3Lw1W83Hmps3ZWibU0T_PLFP-3ZicQ9U3HjTNLGz0QtDVWk_k4wywRc5OSYaMEAQ7xSYSILnuuOdDXZXjtEiB1VN3pRASeOYLdA-WquF5sEZsc2A=s2048" alt="" width="563"><figcaption></figcaption></figure>

Next, confirm it is activated in the Snapshot advanced settings in the treasury container.

<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FShCDO5PNeucjpEYVWyKz%2Fimage.png?alt=media&#x26;token=d06ae91c-0565-40eb-826d-cc13025d561a" alt=""><figcaption></figcaption></figure>

You're finished! Time to create your [first proposal.](snapshot-tutorial)&#x20;