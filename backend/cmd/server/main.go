package main

import (
	"log"
	"net/http"
	"os"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	r := chi.NewRouter()

	// Middleware
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.RequestID)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"http://localhost:5173", "http://localhost:3000"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300,
	}))

	// Health check endpoint
	r.Get("/api/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"status":"ok"}`))
	})

	// API routes placeholder
	r.Route("/api", func(r chi.Router) {
		// User routes
		r.Post("/users", placeholderHandler("register"))
		r.Post("/users/login", placeholderHandler("login"))
		r.Get("/user", placeholderHandler("get current user"))
		r.Put("/user", placeholderHandler("update user"))

		// Profile routes
		r.Get("/profiles/{username}", placeholderHandler("get profile"))
		r.Post("/profiles/{username}/follow", placeholderHandler("follow user"))
		r.Delete("/profiles/{username}/follow", placeholderHandler("unfollow user"))

		// Article routes
		r.Get("/articles", placeholderHandler("list articles"))
		r.Get("/articles/feed", placeholderHandler("get feed"))
		r.Post("/articles", placeholderHandler("create article"))
		r.Get("/articles/{slug}", placeholderHandler("get article"))
		r.Put("/articles/{slug}", placeholderHandler("update article"))
		r.Delete("/articles/{slug}", placeholderHandler("delete article"))

		// Favorite routes
		r.Post("/articles/{slug}/favorite", placeholderHandler("favorite article"))
		r.Delete("/articles/{slug}/favorite", placeholderHandler("unfavorite article"))

		// Comment routes
		r.Get("/articles/{slug}/comments", placeholderHandler("get comments"))
		r.Post("/articles/{slug}/comments", placeholderHandler("add comment"))
		r.Delete("/articles/{slug}/comments/{id}", placeholderHandler("delete comment"))

		// Tag routes
		r.Get("/tags", placeholderHandler("get tags"))
	})

	log.Printf("Server starting on port %s", port)
	if err := http.ListenAndServe(":"+port, r); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

func placeholderHandler(name string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusNotImplemented)
		w.Write([]byte(`{"message":"` + name + ` endpoint not implemented yet"}`))
	}
}
