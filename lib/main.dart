/// * 1. Bluetooth protocol Introduction.

/// It works in the range of 2.4 Ghz. Bluetooth networks (commonly referred to as piconets)
/// use a master/slave model for communication.
///
/// Single master device can be connected to up to seven slaves. While a slave can only
/// connect with a single master.
///
/// Master can send data to any of its slave as well as request data from them.


/// * 2. Bluetooth addresses.
///
/// Every bluetooth device has a unique 48-bit address (BD_ADDR). Usually represented in the form
/// of a 12 digit hexadecimal value.
/// Most significant half (24-bit) is the OUI (Org. unique identifier) and the lower half 24-bits
/// are the more unique part of the address.


/// * 3. Connection between devices.
///
/// Connection between two bluetooth devices are a multi step process involving three progressive states.
/// a) Inquiry: If two BD know nothing about each other, any one of them must run an inquiry request
/// to try to discover the other. The BD listening to such request will respond by sending its address, name etc.
///
/// b) Paging (Connecting): Is the process of forming the connection between two devices. Before this
/// the address of the two devices should be known to each other.
///
/// c) Connection: After the paging is completed. It enters the connection state. While connected,
/// the device can be actively participating or it can be put into a low power sleep mode.
///
/// c.1) Active mode: Regular connected mode, where the devices is actively transmitting or receiving data.
///
/// c.2) Sniff mode: Power saving mode, where the device is less active. It'll sleep and only listen for
/// transmissions at a set interval (e.g. every 100ms).
///
/// c.3) Hold mode: Temporary power saving mode where the device sleeps for a defined period of time.
/// c.4) Park mode: Deepest of sleep mode. A master can command a slave to "park", and that
/// slave will only become active until the master tells it to wake back up.


/// * 4. Bonding and pairing in bluetooth.
///
/// When two BDs share affinity towards each other (they are bonded), they can automatically
/// establish a connection between themselves without any UI interaction.
///
/// Two devices can be bonded by a process called Pairing. Pairing usually requires an authentication
/// process where a user must validate the connection between devices.


/// * 5. Bluetooth profiles.
///
/// Additional protocols that define what kind of data is being transmitted.
/// For example, Hands-free devices uses HSP (HeadSet profile), while keyboards use
/// HID (Human interface device) profile.
///
/// Commonly encountered bluetooth profiles.
///
/// a) SPP (Serial port profile): If you are replacing serial communication interfaces like
/// UART or RS-232 with bluetooth, SPP is the profile for you. SPP is great for
/// sending bursts of data between two devices.
///
/// Using SPP, each connected device can send and receive data as if they are connected
/// with RX and TX lines.


/// * 6. Common Versions.
/// Bluetooth v4.0 split the bluetooth intro three categories: classic, high-power and low-power.
/// The standout was the low-power (BLE: Bluetooth low power energy).
///
/// It sacrifices range (50m instead of 100m) and data throughput (0.27 Mbps instead of the 0.7-2.1 Mbps) for
/// significant power savings.