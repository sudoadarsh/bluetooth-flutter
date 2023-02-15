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