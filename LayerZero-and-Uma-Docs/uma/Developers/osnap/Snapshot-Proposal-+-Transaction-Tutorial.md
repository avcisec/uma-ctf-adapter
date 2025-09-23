---
description: Snapshot Space Set-up and Transaction Builder
---

# Snapshot Proposal + Transaction Tutorial

Welcome to the Snapshot Proposal + Transaction Tutorial. This guide provides detailed, step-by-step instructions on how configure proposals and transactions in your Snapshot space using oSnap.&#x20;

## Create a Proposal in Snapshot with oSnap

In your Snapshot space:

1. Click **'New Proposal'**
2. Fill in the title, description, and discussion link
3. Click **'Continue'**
4. Click the checkbox to use oSnap. _Please note, this will restrict to basic voting._
5. Set the voting period to meet the Safe oSnap module's minimum requirements.
6. Click **'Continue'**

<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FYjc3GW27rbrZdEUUUreA%2FScreenshot%202023-11-14%20at%201.48.32%20PM.png?alt=media&#x26;token=d65c92e0-064f-4b37-9f23-0496c5873e55" alt="" width="474"><figcaption></figcaption></figure>

For more information on creating a proposal, please refer to the [Snapshot documentation. ](https://docs.snapshot.org/user-guides/proposals/create)

## Add Transactions to Your Snapshot Proposal

The oSnap transaction builder allows DAOs to add transactions when creating a Snapshot proposal. The transaction builder has forms for transferring funds, transferring collectables, contract interactions or raw transaction data.\
\
The example proposal below proposes a funds transfer of 0.000005 ETH.

<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2Fsz2iJh0yzJbUEBucnV0Y%2FScreenshot%202024-02-26%20at%206.26.58%20PM.png?alt=media&#x26;token=332d5c96-3b2b-4802-a427-730e91fce187" alt=""><figcaption></figcaption></figure>



## Tenderly Transaction Simulation

Before publishing your transaction, oSnap includes a built-in Tenderly simulation to simulate the transaction beforehand.

First, build your transaction.

<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FNafRfSUPZ1LYqAQw1oZw%2Fimage.png?alt=media&#x26;token=b2627df3-cfa9-4d7f-abe4-cc339bcaa3d1" alt=""><figcaption></figcaption></figure>

Then, click **simulate transaction**. This will simulate the transaction and return a **transaction passed** or **transaction failed** result.

<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FsE6dm9tDoftLLuTay6lW%2Fimage.png?alt=media&#x26;token=ff0a3d80-713b-4703-a175-069490ccc0f4" alt=""><figcaption></figcaption></figure>

You can also view the results of the simulation in Tenderly.

<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FZ3hLWBwJ0Sgp3IOJ6weZ%2Fimage.png?alt=media&#x26;token=eade5b21-701a-416b-b391-6dcd77e0fb6b" alt=""><figcaption></figcaption></figure>

## Automatic Transaction Execution on Mainnets

For Snapshot proposals that pass on mainnets, UMA bots send a transaction requesting execution of the transactions and post a bond to UMA's Optimistic.&#x20;

After the Optimistic Oracle verifies that the transactions and associated transactions are valid, UMA bots will execute these transactions for oSnap modules using default settings, provided they require less than 500,000 gas. \
\
For testnet transaction execution, see the section below.

## Manual Transaction Execution on Testnets

After the voting period has ended, if the proposal passes and meets the criteria set in the rules of the oSnap module, the 0.000005 ETH transfer can be proposed. Anyone can propose the transactions by clicking the 'Request execution' button.&#x20;



<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FIpV1qdASMol7TOHwKe7m%2Fimage.png?alt=media&#x26;token=081188ae-375b-4eab-b2d8-9beeac6bcfb9" alt=""><figcaption></figcaption></figure>

Requesting execution requires sending a transaction along with a bond (bonds are not required on testnets). This starts the Optimistic Oracle liveness period, during which anyone can dispute the proposal.&#x20;

After requesting execution, the Snapshot proposal displays the date and time when the liveness period will expire. If the request is not disputed by this time, the requester's bond will be returned and the transactions will be able to be executed.

<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FppTbC56wCdGvhJrxn3EX%2Fimage.png?alt=media&#x26;token=245d9436-9126-4432-88f7-8924aba08aaf" alt=""><figcaption></figcaption></figure>

After the challenge period has been completed, the Snapshot proposal gives the user the option to 'Execute transaction batch'. Signing this transaction will execute the transactions and return the bond to the requester.

<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2F4tBKZjG34e7I9e3qzuy9%2Fimage.png?alt=media&#x26;token=fe1edfb0-d340-4ccd-a955-0ac57795beb9" alt=""><figcaption></figcaption></figure>

After executing our example proposal, the below shows the 0.000005 ETH transfer being executed.

<figure><img src="https://2020722513-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FKdaoNjf9AzgWFNHyPo5b%2Fuploads%2FymZfZb8oTbqAS2R3JA5J%2Fimage.png?alt=media&#x26;token=33b9e908-d6c1-4938-bbe4-463d75a6d161" alt=""><figcaption></figcaption></figure>