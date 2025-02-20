open Crypto

let test_call contents =
  let encoder = new Base32.base32 `Encode `Standard in
  let encoded_string = encoder#run contents in
  encoded_string
