import styles from '../styles/PostItem.module.css'

function PostItem() {
  return (
    <div className={styles.container}>
      <h1>Create your item</h1>
      <form className={styles.form}>
        <input type="text" placeholder='Name...' />
        <input type="text" placeholder='img URL...' />
        <input type="number" placeholder='Price...'/>
        <img src="" alt="" />
        <button type='submit'>Create item</button>
      </form>
    </div>
  )
}

export default PostItem