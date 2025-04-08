import { useState } from 'react'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div className="app-container">
      <header className="app-header">
        <h1>تطبيق إدارة المبيعات</h1>
        <p>نظام متكامل لإدارة المبيعات وعروض الأسعار</p>
      </header>
      <main className="app-main">
        <div className="card">
          <button onClick={() => setCount((count) => count + 1)}>
            لقد نقرت {count} مرات
          </button>
          <p>
            اضغط على الزر لزيادة العدد
          </p>
        </div>
      </main>
    </div>
  )
}

export default App