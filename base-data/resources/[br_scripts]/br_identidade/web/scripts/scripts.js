const app = {
  open: (data) => {
    app.updateInformations(data)
    document.body.style.display = 'flex'
  },
  close: () => {
    document.body.style.display = 'none'
  },
  updateInformations: (data) => {
    document.querySelector('#id').textContent = data.id
    document.querySelector('#name').textContent = data.name
    document.querySelector('#age').textContent = data.birth
    document.querySelector('#phone').textContent = data.telephone

    document.querySelector('#bank').textContent = new Intl.NumberFormat('pt-br', { style: 'currency', currency: 'BRL' }).format(data.bank ?? 0)
    document.querySelector('#wallet').textContent = new Intl.NumberFormat('pt-br', { style: 'currency', currency: 'BRL' }).format(data.wallet ?? 0)

    document.querySelector('#org').textContent = data.org ?? 'Sem organização'
    document.querySelector('#carry').textContent = data.carry ? 'Porte Aporvado' : 'Sem porte'
    document.querySelector('#staff').textContent = data.staff ?? 'Sem cargo'
    document.querySelector('#status').textContent = data.spouse.name ? data.spouse.name : 'Solteiro'
    app.updateVips(data)
  },
  updateVips: ({ vips }) => {
    document.querySelector('#app footer').innerHTML = ''
    if (!vips) return
    vips.forEach(vip => {
      document.querySelector('#app footer').innerHTML += `
        <div class="vip">
          <h4>VIP</h4>
          <p>${vip.vip}</p>
        </div>
      `
    })
  },
}

window.addEventListener('message', ({ data }) => {
  if (data.action === 'open') app.open(data.info);
  if (data.action === 'close') app.close();
})

if (!window.invokeNative) {
  document.body.style.display = 'flex'
  document.body.style.background = '#1c1c1c'

  window.postMessage({
    action: 'open',
    vips: ['a', 'b', 'c']
  })
}