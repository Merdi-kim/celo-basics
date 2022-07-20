import { useState } from 'react'
import { useCelo } from '@celo/react-celo'
import { contractAddress } from '../utils'
import Store from '../artifacts/contracts/Store.sol/Store.json'
import styles from '../styles/PostItem.module.css'
import Router from 'next/router'

function PostItem() {

  const [itemData, setItemData] = useState({
    name:"",
    imageUrl:"",
    price:0
  })

  const {kit, address } = useCelo();

  const createItem = async(e) => {
    e.preventDefault()
    const contract = new kit.connection.web3.eth.Contract(Store.abi, contractAddress)
    try{
      await contract.methods.postItem(itemData.name, itemData.imageUrl, kit.connection.web3.utils.toWei(`${itemData.price}`, 'ether'), 20).send({from: address})
      Router.push('/')
    }
    catch (err) {
      console.log(err)
    }
  }

  return (
    <div className={styles.container}>
      <h1>Create your item</h1>
      <form className={styles.form} onSubmit={createItem}>
        <input type="text" placeholder='Name...' required onChange={(e) => setItemData({ ...itemData, name:e.target.value})} />
        <input type="text" placeholder='img URL...' required onChange={(e) => setItemData({ ...itemData, imageUrl:e.target.value})} />
        <input type="number" placeholder='Price...' required onChange={(e) => setItemData({ ...itemData, price:e.target.value})} />
        { itemData.imageUrl && <img src={itemData.imageUrl} alt="" />}
        <button type='submit'>Create item</button>
      </form>
    </div>
  )
}

export default PostItem