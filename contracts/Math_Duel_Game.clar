(define-map player-score {player: principal} uint)
(define-map player-duel {player: principal} principal)

(define-constant err-not-opponent (err u100))
(define-constant err-invalid-score (err u101))
(define-constant err-no-duel (err u102))

(define-public (start-duel (opponent principal))
  (begin
    (map-set player-duel {player: tx-sender} opponent)
    (map-set player-duel {player: opponent} tx-sender)
    (ok {duel-started: true, players: (tuple (p1 tx-sender) (p2 opponent))})))

(define-public (submit-score (score uint))
  (let ((opponent-opt (map-get? player-duel {player: tx-sender})))
    (match opponent-opt opponent
      (begin
        (asserts! (not (is-eq tx-sender opponent)) err-not-opponent)
        (asserts! (<= score u100) err-invalid-score)
        (map-set player-score {player: tx-sender} score)
        (ok {score-submitted: true, player: tx-sender, score: score}))
      err-no-duel)))
