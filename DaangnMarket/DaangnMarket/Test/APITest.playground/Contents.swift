import UIKit

let phone = "010 9813 8829"
let regex = "^01([0|1|6|7|8|9]?)\\s?([0-9]{3,4})\\s?([0-9]{4})$"
let result = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phone)

private func checkValidNickname(_ nickname: String) -> Bool {
  let regex = "^[가-힣|a-z|A-Z|0-9|\\*]+$"
  return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickname)
}
checkValidNickname("집엑..")


//func hasCharacters() -> Bool{
//  do{
//    let regex = try NSRegularExpression(pattern: "^[a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ\\s]$", options: .caseInsensitive)
//    if let _ = regex.firstMatch(in: "집에", options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, "집에".count)) {
//      return true
//    }
//  }catch{
//    print(error.localizedDescription)
//    return false
//  }
//  return false
//}
//hasCharacters()


//
//
//class TimerTest {
//  var timer: Timer?
//  var timeLeft = 60
//
//  func start() {
//    print("Timer Start")
//    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
//  }
//
//  func end() {
//    print("Timer End")
//    timer?.invalidate()
//  }
//
//  @objc func onTimerFires() {
//    timeLeft -= 1
//    print("\(timeLeft) seconds left")
//
//    if timeLeft <= 0 {
//      timer?.invalidate()
//      timer = nil
//    }
//  }
//}
//let test = TimerTest()
//test.start()
//
//
//
//
//func isPhone(candidate: String) -> Bool {
//  let regex = "^01([0|1|6|7|8|9]?)\\s?([0-9]{3,4})\\s?([0-9]{4})$"
//  return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: candidate)
//}
//
//func isEmail(candidate: String) -> Bool{
//  let regex = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
//  return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: candidate)
//}
//
//let phone = "010 9813 8829"
//isPhone(candidate: phone)
//
//let new = phone
//  .replacingCharacters(in: Range(NSRange(location: 0, length: 1), in: phone)!, with: "+82")
//  .replacingOccurrences(of: " ", with: "")
//print("Re :", new)
//
//
//
//
///*
//
//
// // Firebase Test
// let phoneNumber = "+821012345678"
// let testVerificationCode = "150803"
//
// Auth.auth().languageCode = "kr"
// Auth.auth().settings?.isAppVerificationDisabledForTesting = true
// PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
//   if let error = error { return print(error.localizedDescription) }
//   else {
//     print("Verification ID :", verificationID ?? "unknown")
//     let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "",
//                                                                verificationCode: testVerificationCode)
//     Auth.auth().signIn(with: credential) { (authData, error) in
//       if let error = error { return print(error.localizedDescription) }
//       else {
//         guard let user = authData?.user else { return }
//         print("=================== user =====================")
//         dump(user)
//         print("========================================")
//
//         print("Display Name :", user.displayName ?? "unknown")
//         print("Email :", user.email ?? "unknown")
//         print("Is Anonymous :", user.isAnonymous)
//         print("Is Email Verified :", user.isEmailVerified)
//         print("Phone Number :", user.phoneNumber ?? "unknown")
//         print("Provider ID :", user.providerID)
//         print("Provider Data :", user.providerData)
//         print("Refresh Token :", user.refreshToken ?? "unknown")
//         print("UID :", user.uid)
//         print("Metadata Creation Date :", user.metadata.creationDate)
//         print("Metadata Latest Sign In Date :", user.metadata.lastSignInDate)
//         print("Multi Factor Enrolled Factors :", user.multiFactor.enrolledFactors)
//         print("Photo URL :", user.photoURL ?? "unknown")
//
//         user.getIDToken { (token, error) in
//           print("Token :", token)
//         }
//
//         user.updateEmail(to: "test@test.com") { (error) in
//           if let error = error { print(error.localizedDescription) }
//           else {
//             print("Update Email")
//             print("Current Email :", Auth.auth().currentUser?.email ?? "unknown")
//           }
//         }
//       }
//     }
//   }
// }
// */
