import React, { useState } from "react";
import { ethers } from "ethers";

function App() {
  const [contractAddress, setContractAddress] = useState("");
  const [status, setStatus] = useState("");

  const contractABI = [
    "function joinFund() public",
    "function getMembers() public view returns (address[])"
  ];

  async function joinFund() {
    if (!window.ethereum) {
      setStatus("MetaMask not detected");
      return;
    }

    try {
      await window.ethereum.request({ method: "eth_requestAccounts" });
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const contract = new ethers.Contract(contractAddress, contractABI, signer);
      
      const tx = await contract.joinFund();
      setStatus("Transaction sent: " + tx.hash);
      await tx.wait();
      setStatus("Successfully joined the fund!");
    } catch (err) {
      console.error(err);
      setStatus("Error: " + (err.reason || err.message));
    }
  }

  return (
    <div className="min-h-screen bg-gray-900 text-white flex flex-col items-center justify-center p-4">
      <h1 className="text-3xl font-bold mb-4">Laxmi ChitFund</h1>
      <input
        type="text"
        placeholder="Enter contract address"
        value={contractAddress}
        onChange={(e) => setContractAddress(e.target.value)}
        className="p-2 rounded text-black w-80 mb-4"
      />
      <button
        onClick={joinFund}
        className="bg-blue-600 hover:bg-blue-700 px-4 py-2 rounded"
      >
        Join Fund
      </button>
      <p className="mt-4">{status}</p>
    </div>
  );
}

export default App;
