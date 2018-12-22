
import Dispatch
import struct Foundation.TimeInterval
import class Foundation.RunLoop


private func dispatchInterval(_ interval: Foundation.TimeInterval) -> DispatchTimeInterval {
    precondition(interval >= 0.0)

    return DispatchTimeInterval.milliseconds(Int(interval * 1000.0))
}

private func schedulePeriodic(leeway: DispatchTimeInterval, startAfter: TimeInterval, period: TimeInterval, action: @escaping () -> ()) -> DispatchSourceTimer {
    let initial = DispatchTime.now() + dispatchInterval(startAfter)

    let timer = DispatchSource.makeTimerSource()

    #if swift(>=4.0)
        // deadline: determines the first delivery time.
        // leeway: When setting up a timer firing at a certain time, the system implicitly sets an allowed "leeway" which is a short delay within the timer may actually fire.
        // - https://stackoverflow.com/a/49190972/796919
        // - https://stackoverflow.com/a/23179776/796919
        timer.schedule(deadline: initial, repeating: dispatchInterval(period), leeway: leeway)
    #else
        timer.schedule(deadline: initial, interval: dispatchInterval(period), leeway: leeway)
    #endif

    timer.setEventHandler {
        action()
    }
    timer.resume()
    return timer
}

func dispatchSourceTimerMain() {
    // Keep a reference to the timer, otherwise gc will deinit the timer.
    let timer = schedulePeriodic(leeway: .milliseconds(0), startAfter: 0.2, period: 0.3) {
        print("action")
    }

    RunLoop.main.run()
}
