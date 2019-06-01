export const requests = {
    open: () => state => {
        const socket = new WebSocket('ws://localhost:3000/encode')
    },
    encode: () => state  => {
        var request = new XMLHttpRequest()
        request.onreadystatechange = () => {
            if (request.readyState == 4 && request.status == 200) {
                console.log(JSON.parse(request.responseText))
            }
        }

        request.open('POST', 'http://localhost:3000/encode', true)
        request.setRequestHeader("Content-Type", "application/json")
        request.send(JSON.stringify(state))
    }
}
