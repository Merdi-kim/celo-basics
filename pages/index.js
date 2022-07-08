import { useEffect, useState } from 'react'
import Head from 'next/head'
import Link from 'next/link'
import { useCelo } from '@celo/react-celo';
import { contractAddress } from '../utils';
import Store from '../artifacts/contracts/Store.sol/Store.json'
import styles from '../styles/Home.module.css'

export default function Home() {

  const { connect, address, kit } = useCelo();
  const contract = new kit.connection.web3.eth.Contract(Store.abi, contractAddress)

  const [myItems, setMyItems] = useState([])

  const unlistStore = async(e) => {
    const id = e.target.getAttribute("data-id");
    try{
      await contract.methods.deleteProduct(id).send({from:address})
    }
    catch (err) {
      console.log(err)
    }
  }

  const buyItem = async(e) => {
    const id = e.target.getAttribute("data-id")
    const price = e.target.getAttribute("data-price")
    try{
      await contract.methods.buyItem(id).send({from:address, value: kit.connection.web3.utils.fromWei(price)})
    }
    catch (err) {
      console.log(err)
    }
  }

  const fetchItems = async() => {
    try{
      const data = await contract.methods.getAllItems().call()
      setMyItems(data)
    }
    catch (err) {
      console.log(err)
    }
  } 
  useEffect(() => {
    fetchItems()
  }, [])

  return (
    <div className={styles.container}>
      <Head>
        <title>Celo Store</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <nav>
          <h1>Celo Market</h1>
          <>
           {!address ? <button onClick={connect}>Connect wallet</button> : <Link href={'/post-item'}>New product</Link>  }
          </>
        </nav>

        <div className={styles.items}>
          {
            myItems?.map(({id, seller, name, image, price}) => <div className={styles.item} key={id}>
              <img src={image} alt="" />
              <section>
                <h3>{name}</h3>
                <span>{kit.connection.web3.utils.fromWei(price)}$</span>
              </section>
              { seller == address && <button data-id={id} className={styles.delete} onClick={unlistStore}>Delete</button>}
              <button data-id={id} data-price={price} onClick={buyItem}>Buy</button>
            </div> )
          }
        </div>
      </main>
    </div>
  )
}
