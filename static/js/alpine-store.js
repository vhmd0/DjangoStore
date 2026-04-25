document.addEventListener("alpine:init", () => {
  Alpine.store("toast", {
    message: "",
    type: "info",
    visible: false,
    timer: null,

    show(message, type = "info") {
      this.message = message;
      this.type = type;
      this.visible = true;
      if (this.timer) clearTimeout(this.timer);
      this.timer = setTimeout(() => {
        this.visible = false;
      }, 4000);
    },

    hide() {
      this.visible = false;
      if (this.timer) clearTimeout(this.timer);
    },
  });

  Alpine.store("cart", {
    adding: false,
    addedId: null,

    async addToCart(form) {
      if (this.adding) return Promise.reject(new Error("Already adding"));
      this.adding = true;
      console.log("addToCart function called", form);

      const formData = new FormData(form);
      const csrf = Alpine.store("utils").csrf();
      console.log("CSRF token:", csrf);

      try {
        console.log("Fetching:", form.action);
        const res = await fetch(form.action, {
          method: "POST",
          headers: {
            "X-Requested-With": "XMLHttpRequest",
            "X-CSRFToken": csrf,
          },
          body: formData,
        });
        console.log("Response status:", res.status);
        const data = await res.json();
        console.log("Response data:", data);
        if (res.ok && data.success) {
          this.updateUI(data);
          this.addedId = form.dataset.productId || Date.now();
          setTimeout(() => { this.addedId = null; }, 1500);
          return data;
        } else {
          Alpine.store("toast").show(data.error || "Error updating cart", "error");
          throw new Error(data.error || "Error");
        }
      } catch (e) {
        console.error("Cart error:", e);
        Alpine.store("toast").show("Connection error", "error");
        throw e;
      } finally {
        this.adding = false;
      }
    },

    updateUI(data) {
      const cartBody = document.querySelector(".js-cart-body");
      const cartFooter = document.querySelector(".js-cart-footer");
      
      if (data.items_html && cartBody) cartBody.innerHTML = data.items_html;
      if (data.footer_html && cartFooter) cartFooter.innerHTML = data.footer_html;
      document.querySelectorAll(".js-cart-badge").forEach((el) => (el.textContent = data.cart_count));
    },

    async refresh() {
      try {
        const url = window.CART_FRAGMENT_URL || "/cart/fragment/";
        const res = await fetch(url, {
          headers: { "X-Requested-With": "XMLHttpRequest" },
        });
        const data = await res.json();
        this.updateUI(data);
      } catch (e) {
        console.error("Cart refresh error:", e);
      }
    },

    showOffcanvas() {
      window.dispatchEvent(new CustomEvent("cart-open"));
    },
  });

  Alpine.store("utils", {
    async copy(text) {
      try {
        await navigator.clipboard.writeText(text);
        return true;
      } catch (e) {
        console.error("Copy error:", e);
        return false;
      }
    },

    csrf() {
      return (
        document.querySelector("[name=csrfmiddlewaretoken]")?.value ||
        document.cookie
          .split("; ")
          .find((c) => c.startsWith("csrftoken="))
          ?.split("=")[1] ||
        ""
      );
    },
  });
});
