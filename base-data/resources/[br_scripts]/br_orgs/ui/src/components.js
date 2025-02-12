document.addEventListener("DOMContentLoaded", () => {
    const content = document.getElementById("Content");
    const menuItems = document.querySelectorAll(".card-nav-menu");

    if (!content || menuItems.length === 0) {
        console.error('Erro: Elementos essenciais não foram encontrados.');
        return;
    }

    const pages = [
        { title: "INÍCIO", content: "<h2>Bem-vindo à Página Inicial</h2><p>Conteúdo inicial...</p>" },
        { title: "RANKING", content: "<h2>Página de Ranking</h2><p>Aqui estão os melhores do ranking.</p>" },
        { title: "METAS", content: "<h2>Seus Objetivos e Metas</h2><p>Defina e acompanhe suas metas.</p>" },
        { title: "BANCO", content: "<h2>Informações do Banco</h2><p>Dados bancários e transações.</p>" },
        { title: "CONFIG", content: "<h2>Configurações do Sistema</h2><p>Ajuste suas configurações.</p>" },
        { title: "PARCERIAS", content: "<h2>Parcerias e Colaborações</h2><p>Oportunidades de parcerias.</p>" }
    ];

    function showPage(index) {
        content.innerHTML = `<div class="page-content">${pages[index].content}</div>`;
        menuItems.forEach(item => item.classList.remove("selected-nav"));
        menuItems[index].classList.add("selected-nav");
    }

    menuItems.forEach((item, index) => {
        item.addEventListener("click", () => showPage(index));
    });

    showPage(0); // Exibir a primeira página ao carregar
});
