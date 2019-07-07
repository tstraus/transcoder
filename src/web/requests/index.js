export const requests = {
    open: () => state => {
        const socket = new WebSocket('ws://localhost:3000/encode')
        socket.onmessage = (event) =>
        {
            const data = JSON.parse(event.data)
            //console.log(data)
            console.log(data.input + ' -> ' + data.output + ' : ' + data.id + ' -> ' + data.progress + '%')

            state.transcodes[data.id] = data.progress

            //console.log(state.transcodes[1].toString())
        }
    },
    encode: () => state => {
        var request = new XMLHttpRequest()
        request.onreadystatechange = () =>
        {
            //if (request.readyState == 4 && request.status == 200)
            //{
            //    console.log(JSON.parse(request.responseText))
            //}
        }

        request.open('POST', 'http://localhost:3000/encode', true)
        request.setRequestHeader("Content-Type", "application/json")
        request.send(JSON.stringify(state))
    }
}
