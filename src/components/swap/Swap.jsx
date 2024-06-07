import React, { useState } from 'react';
import './Swap.css'

const Swap = () => {
  const [inputValue, setInputValue] = useState('');
  const [outputValue, setOutputValue] = useState('');

  const handleInputChange = (e) => {
    setInputValue(e.target.value);
  };

  return (
    <div className='swap'>
      <input 
        className='input'
        type="text" 
        value={inputValue} 
        onChange={handleInputChange} 
        placeholder="Enter amount"
      />
      <input 
        className='input'
        type="text" 
        value={outputValue} 
        readOnly 
        placeholder="Output amount"
      />
      <button>Swap</button>
    </div>
  );
};

export default Swap;
